#!/usr/bin/ruby
require 'distem'

img = "file:///home/amerlin/image/peer.tgz"
img_t = "file:///home/amerlin/image/tracker.tgz"
ip = `ip -br a | grep eth0| tr -s ' ' | cut -d' ' -f3 | cut -d'/' -f 1`.strip

Distem.client do |cl|
  hosts = cl.pnodes_info.keys
  cl.vnetwork_create('vnet', '10.144.0.0/24', {'network_type' => 'vxlan'})
  cl.vnetwork_create('vadm', '10.144.5.0/24', {'network_type' => 'vxlan'})

  cl.vnode_create("tracker",
                  {'host' => hosts[0],
                  'vfilesystem' =>{'image' => img_t},
                  'vifaces' => [ {'name' => 'if0', 'vnetwork' => 'vnet'},
                                 {'name' => 'if1', 'vnetwork' => 'vadm'}],
                  })

  cl.vnode_create("peer",
                  {'host' => hosts[0],
                  'vfilesystem' =>{'image' => img},
                  'vifaces' => [{'name' => 'if0', 'vnetwork' => 'vnet',
                                 'output' => {'bandwidth' => {'rate' => "5kbps"}}},
                                {'name' => 'if1', 'vnetwork' => 'vadm'}],
                  })

  (0..3).each do |x|
      cl.vnode_create("peer0#{x}",
                {'host' => hosts[1],
                'vfilesystem' =>{'image' => img, 'shared' => true},
                'vifaces' => [{'name' => 'if0', 'vnetwork' => 'vnet',
                               'output' => {'bandwidth' => {'rate' => "30kbps"}},
                               'input' => {'bandwidth' => {'rate' => "30kbps"}}},
                               {'name' => 'if1', 'vnetwork' => 'vadm'}],
                })
  end

  peers = (0..3).map {|x| "peer#{x.to_s.rjust(2,'0')}"}
  peers << 'peer'
  nodes = peers
  nodes << 'tracker'
  puts "Starting vnodes..."
  cl.vnodes_start(nodes)
  puts "Waiting for vnodes to be here..."
  sleep(30)
  ret = cl.wait_vnodes({'timeout' => 1200, 'port' => 22})
  if ret
    puts "Setting global /etc/hosts"
    cl.set_global_etchosts
  else
    puts "vnodes are unreachable"
  end

  sleep(40)
  puts "Launching daemon transmission"

  cl.vnode_execute('tracker', "cp /bin/opentracker /usr/bin/opentracker")
  cl.vnode_execute('tracker', "systemctl start opentracker")
  cl.vnode_execute('peer', "dd if=/dev/urandom of=file count=50 bs=10M")
  cl.vnode_execute('peer', "transmission-create -o file.torrent -t 'http://tracker-vnet:6969/announce' file")

  peers.each do |peer|
    cl.vnode_execute(peer, "mkdir #{peer}")
    cl.vnode_execute(peer, "rm /etc/resolv.conf")
    cl.vnode_execute(peer, "scp -o StrictHostKeyChecking=no root@peer-vadm:file.torrent ~/#{peer}")
    cl.vnode_execute(peer, "transmission-daemon -a 10.144.5.254,127.0.0.1 -w /root/#{peer} -O -Y -M")
    cl.vnode_execute(peer, "transmission-remote 127.0.0.1 --add /root/#{peer}/file.torrent")
    print("starting getter")
    cl.vnode_execute(peer, "systemctl start exporter")

  end

end

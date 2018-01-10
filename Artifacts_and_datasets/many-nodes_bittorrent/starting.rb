#!/usr/bin/ruby
require 'distem'


Distem.client do |cl|
  peers = (0..99).map {|x| "peer#{x.to_s.rjust(2,'0')}"}

  peers.each do |peer|
    cl.vnode_execute(peer, "transmission-remote 127.0.0.1 -t 1 -S")
  end
  sleep(25)
  peers.each do |peer|
    cl.vnode_execute(peer, "transmission-remote 127.0.0.1 -t 1 -s")
    sleep(4)
  end

end

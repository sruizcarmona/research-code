for i in {1..254}; do echo $i;for f in {1..254}; do if ping 169.254.$i.$f -c 1 -W0.5 -q | grep mdev -q; then echo 169.254.$i.$f ; break; fi; done; done

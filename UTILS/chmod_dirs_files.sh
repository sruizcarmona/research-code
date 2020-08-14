#!/bin/bash
find . -type d -exec chmod 0$1 {} \;
find . -type f -exec chmod 0$2 {} \;
#find . -type d -exec chmod 0755 {} \;
#find . -type f -exec chmod 0644 {} \;



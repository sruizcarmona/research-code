#!/bin/csh

foreach file ( qsub*.sh )
qsub $file
end

PROCEDURE apu_00X10
SET FILTER TO dgprop1='00X10'
REPLACE ALL valid WITH .f.
SET FILTER TO dgprop2='00X10'
REPLACE ALL valid WITH .f.
SET FILTER TO dgprop3='00X10'
REPLACE ALL valid WITH .f.
SET FILTER TO dgprop4='00X10'
REPLACE ALL valid WITH .f.
DO _14logi.fxp
return
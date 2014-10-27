 awk '{
	 if ($3 >=35 && $4 >= 35 && $5 >= 35)
		 	print $0,"=>","Pass";
	 else
		 	print $0,"=>","Fail";
 }' student-marks

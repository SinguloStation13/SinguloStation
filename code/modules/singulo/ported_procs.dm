/atom/proc/GetAllContents(var/T, ignore_flag_1)
	var/list/processing_list = list(src)
	if(T)
		. = list()
		var/i = 0
		while(i < length(processing_list))
			var/atom/A = processing_list[++i]
			//Byond does not allow things to be in multiple contents, or double parent-child hierarchies, so only += is needed
			//This is also why we don't need to check against assembled as we go along
			if (!(A.flags_1 & ignore_flag_1))
				processing_list += A.contents
				if(istype(A,T))
					. += A
	else
		var/i = 0
		while(i < length(processing_list))
			var/atom/A = processing_list[++i]
			if (!(A.flags_1 & ignore_flag_1))
				processing_list += A.contents
		return processing_list

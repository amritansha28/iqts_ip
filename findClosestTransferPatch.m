%% Helper function to return a random patch of the closest patch to the given patch in the original image
function selected_patch = findClosestTransferPatch(ref_patches,target_patch,texture_pic,error_tolerance,overlap_type,overlap_size,patch_size,alph,corr_type);
	[h,w,num_chan] = size(texture_pic);
	num_rows = h-patch_size+1;
	num_cols = w-patch_size+1;
	error_patch = zeros([num_rows,num_cols]);
	min_error = 10000000.0;
	for i=1:h-patch_size+1
		for j=1:w-patch_size+1
			curr_patch = texture_pic(i:i+patch_size-1,j:j+patch_size-1,:);
			overlap_error = findError(curr_patch,ref_patches,overlap_type,overlap_size,patch_size);
			correspondence_error = 	findCorrespondenceError(curr_patch,target_patch,corr_type);
			total_error = alph*overlap_error + (1-alph)*correspondence_error;
			if total_error == 0
				error_patch(i,j) = 0;
			else
				error_patch(i,j) = total_error;
				if total_error < min_error
					min_error = total_error;
				end
			end			
		end
	end
	
	min_error = min_error*(1+error_tolerance);

	[close_patches_i, close_patches_j] = find(error_patch<min_error);
	x = randi(length(close_patches_i),1);

	start_i = close_patches_i(x);
	start_j = close_patches_j(x);

	selected_patch = texture_pic(start_i:start_i+patch_size-1, start_j:start_j+patch_size-1, :);
end
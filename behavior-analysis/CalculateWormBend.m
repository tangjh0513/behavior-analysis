function bend = CalculateWormBend(centerline)
% Calculate the worm bend

% the bend is defined as the RMS(kL), where k and L are the curvature and length of centerline
normalized_curvature = Compute_Curvature(centerline);
bend = sqrt(sum(normalized_curvature.^2));

end
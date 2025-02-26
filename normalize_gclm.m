function glcm = normalize_gclm(glcm)
  

if any(glcm(:))
  glcm = glcm ./ sum(glcm(:));
end
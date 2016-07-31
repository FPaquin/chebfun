function v = norm( F )
%NORM   Frobenius norm of a DISKFUNV.
%   V = NORM(F) returns the Frobenius norm of the two/three components, i.e. 
%       V = sqrt(norm(F1).^2 + norm(F2).^2),
%   or
%       V = sqrt(norm(F1).^2 + norm(F2).^2 + norm(F3).^2) .

% Copyright 2016 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information. 

% Empty check: 
if ( isempty( F ) ) 
    v = []; 
    return
end
V = sum( svd( F.components{1} ).^2 ) + sum( svd( F.components{2} ).^2 );
 
v = sqrt(v); 

end

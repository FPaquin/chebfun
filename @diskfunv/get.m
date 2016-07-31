function val = get( f, propName )
%GET   Get DISKFUNV properties.
%
%   P = GET(F, PROP) returns the property P specified in the string PROP from
%   the DISKFUNV F. Valid entries for the string PROP are:
%    'components'  - The DISKFUNs making up the components of F.
%    'nComponents'  - The number of components in a DISKFUN.
%    'isTransposed' - Is the DISKFUNV a column or row vector?
%    'coords' - coordinate system the diskfunv is evaluated in.

% Copyright 2016 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.


if ( numel(f) > 1 )
    val = cell(numel(f));
    for k = 1:numel(f)
        val{k} = get(f(k), propName);
    end
    return
end

switch propName
    case 'components'
        val = f.components;
    case 'nComponents'
        val = f.nComponents; 
    case 'isTransposed'
        val = f.isTransposed;
    case 'coords'
        val = f.coords;
    otherwise
        error('DISKFUN:DISKFUNV:get:propName', ...
            [propName, ' is not a valid DSIKFUNV property.'])
end

end

function F = vertcat( F , G )
%VERTCAT Vertical concatenation of DISKFUNV objects.
%   [F ; f] where F is a DISKFUNV with two components, and f is a CHEBFUN2 or
%   scalar then returns a DISKFUNV with three components.  The first and second
%   component remain unchanged and the third component is f.
% 
%   [f ; F] where F is a DISKFUNV with two components, and f is a CHEBFUN2 or
%   scalar then returns a DISKFUNV with three components. The first is f, and
%   the second and third are the first and second components of F.

% Copyright 2016 by The University of Oxford and The Chebfun2 Developers.
% See http://www.chebfun.org/ for Chebfun2 information.

if ( isempty( F ) || isempty( G ) )
    F = diskfunv;
    return
end

if ( isa(G, 'double') ) 
    Fc = F.components;
    dom = Fc{1}.domain;
    G = diskfun( G, Fc{1}.domain ); 
elseif ( isa(F, 'double') ) 
    Gc = G.components;
    dom = Gc{1}.domain;
    F = diskfun( F, Gc{1}.domain ); 
elseif ( isa(G, 'diskfun') )
    if ( ~domainCheck(F.components{1}, G) ) 
        error('CHEBFUN:DISKFUNV:vertcat:domain', 'Inconsistent domains.')
    end
    dom = G.domain; 
else
    error('CHEBFUN:DISKFUNV:vertcat:notSupported', ...
        'Vertical concatenation of these objects is not supported.')
end

if ( isa(F, 'diskfunv') )
    op = [ F.components, {G} ]; 
else
    op = [ {F}, G.components ]; 
end

F = diskfunv( op, dom ); 

end

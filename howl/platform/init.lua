--- The native loader for platforms
-- @module howl.platform

if fs and term then
	return require "howl.platform.cc"
elseif _G.component then
	return require "howl.platform.oc"
else
	return require "howl.platform.native"
end

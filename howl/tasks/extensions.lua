--- Basic extensions to classes
-- @module howl.tasks.extensions

local Runner = require "howl.tasks.Runner"
local colored = require "howl.lib.colored"

local TaskExtensions = {}

--- Prints all tasks in a TaskRunner
-- Extends the @{howl.tasks.Runner} class
-- @tparam string indent The indent to print at
-- @tparam boolean all Include all tasks (otherwise exclude ones starting with _)
-- @treturn howl.tasks.Task The created task
function TaskExtensions:ListTasks(indent, all)
	local taskNames = {}
	local maxLength = 0
	for name, task in pairs(self.tasks) do
		local start = name:sub(1, 1)
		if all or (start ~= "_" and start ~= ".") then
			local description = task.description or ""
			local length = #name
			if length > maxLength then
				maxLength = length
			end

			taskNames[name] = description
		end
	end

	maxLength = maxLength + 2
	indent = indent or ""
	for name, description in pairs(taskNames) do
		colored.writeColor("white", indent .. name)
		colored.printColor("lightGray", string.rep(" ", maxLength - #name) .. description)
	end

	return self
end

--- A task for cleaning a directory
-- Extends the @{howl.tasks.Runner} class
-- @tparam string name Name of the task
-- @tparam string directory The directory to clean
-- @tparam table taskDepends A list of tasks this task requires
-- @treturn howl.tasks.Task The created task
function TaskExtensions:Clean(name, directory, taskDepends)
	return self:AddTask(name, taskDepends, function(task, context)
		context.logger:verbose("Emptying directory '" .. directory .. "'")
		local file = fs.combine(context.root, directory)
		if fs.isDir(file) then
			for _, sub in pairs(fs.list(file)) do
				fs.delete(fs.combine(file, sub))
			end
		else
			fs.delete(file)
		end
	end):Description("Clean the '" .. directory .. "' directory")
end

Runner:include(TaskExtensions)

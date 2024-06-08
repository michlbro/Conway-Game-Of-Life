local coreCall do
	local MAX_RETRIES = 15

	local StarterGui = game:GetService('StarterGui')

	function coreCall(method, ...)
		local result = {}
		for retries = 1, MAX_RETRIES do
			result = {pcall(StarterGui[method], StarterGui, ...)}
			if result[1] then
                print("Successfully loaded core call.")
				break
			end
			task.wait(1)
		end
		return unpack(result)
	end
end

coreCall('SetCore', 'ResetButtonCallback', false)
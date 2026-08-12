return {
	{
		"laytan/cloak.nvim",
		opts = {
			patterns = {
				{
					file_pattern = { ".env*", "liquibase.properties" },
					cloak_pattern = { "=.+", ":.+" },
					replace = nil,
				},
			},
		},
	},
}

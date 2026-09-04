return {
	{
		"laytan/cloak.nvim",
		opts = {
			patterns = {
				{
					file_pattern = { ".env*", "liquibase.properties", ".secrets" },
					cloak_pattern = { "=.+", ":.+" },
					replace = nil,
				},
			},
		},
	},
}

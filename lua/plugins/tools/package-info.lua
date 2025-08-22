return {
  "vuki656/package-info.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  event = { "BufRead package.json", "BufRead package-lock.json", "BufRead yarn.lock", "BufRead pnpm-lock.yaml" },
  keys = {
    -- Show package versions
    { "<leader>ns", function() require("package-info").show() end, desc = "Show Package Versions" },
    { "<leader>nh", function() require("package-info").hide() end, desc = "Hide Package Versions" },
    { "<leader>nt", function() require("package-info").toggle() end, desc = "Toggle Package Versions" },
    
    -- Update packages
    { "<leader>nu", function() require("package-info").update() end, desc = "Update Package" },
    { "<leader>nd", function() require("package-info").delete() end, desc = "Delete Package" },
    { "<leader>ni", function() require("package-info").install() end, desc = "Install Package" },
    { "<leader>np", function() require("package-info").change_version() end, desc = "Change Package Version" },
    
    -- Bulk operations
    { "<leader>nU", function() require("package-info").update_all() end, desc = "Update All Packages" },
    { "<leader>nI", function() require("package-info").install_all() end, desc = "Install All Dependencies" },
    
    -- Package search and info
    { "<leader>nf", function() require("package-info").find_package() end, desc = "Find Package" },
    { "<leader>nc", function() require("package-info").check_outdated() end, desc = "Check Outdated" },
  },
  opts = {
    colors = {
      up_to_date = "#3C4048",    -- dim gray for current versions
      outdated = "#d19a66",      -- orange for outdated packages
      invalid = "#ee4b2b",       -- red for invalid versions
    },
    icons = {
      enable = true,
      style = {
        up_to_date = "|  󰄳 ",    -- checkmark
        outdated = "|  󰚰 ",      -- warning triangle
        invalid = "|  󰅚 ",       -- error circle
      },
    },
    autostart = true,
    hide_up_to_date = false,
    hide_unstable_versions = false,
    package_manager = "auto", -- auto-detect npm/yarn/pnpm
    
    -- Display options
    display = {
      loading = {
        enable = true,
        text = "Loading package information...",
      },
      dependencies = {
        enable = true,
        update_on_save = true,
      },
      dev_dependencies = {
        enable = true,
        update_on_save = true,
      },
      peer_dependencies = {
        enable = true,
        update_on_save = false,
      },
      optional_dependencies = {
        enable = true,
        update_on_save = false,
      },
    },
    
    -- Performance
    cache = {
      enable = true,
      ttl = 3600, -- 1 hour cache
    },
    
    -- Integration with other tools
    integrations = {
      telescope = true,
      trouble = true,
    },
  },
  config = function(_, opts)
    require("package-info").setup(opts)
    
    -- Auto-show package info when opening package.json
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
      pattern = { "package.json" },
      callback = function()
        vim.defer_fn(function()
          require("package-info").show()
        end, 100)
      end,
    })
    
    -- Auto-hide when leaving package.json
    vim.api.nvim_create_autocmd({ "BufLeave" }, {
      pattern = { "package.json" },
      callback = function()
        require("package-info").hide()
      end,
    })
    
    -- Custom commands for package management
    vim.api.nvim_create_user_command("PackageUpdate", function()
      require("package-info").update()
    end, { desc = "Update package under cursor" })
    
    vim.api.nvim_create_user_command("PackageUpdateAll", function()
      require("package-info").update_all()
    end, { desc = "Update all packages" })
    
    vim.api.nvim_create_user_command("PackageInstall", function()
      require("package-info").install()
    end, { desc = "Install package under cursor" })
    
    vim.api.nvim_create_user_command("PackageDelete", function()
      require("package-info").delete()
    end, { desc = "Delete package under cursor" })
    
    vim.api.nvim_create_user_command("PackageFind", function()
      require("package-info").find_package()
    end, { desc = "Find and install new package" })
    
    vim.api.nvim_create_user_command("PackageOutdated", function()
      require("package-info").check_outdated()
    end, { desc = "Check for outdated packages" })
  end,
}
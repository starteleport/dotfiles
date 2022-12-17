" NVIM configuration file
"

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" When started as "evim", evim.vim will already have done these settings, bail
" out.
if v:progname =~? "evim"
  finish
endif

" Use my own customizations that are shared between VIM/NVIM
source ~/.vimrc.common

" vim-plug: {{{
call plug#begin('~/.vim/plugged')

Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'

Plug 'nvim-tree/nvim-web-devicons'
Plug 'sainnhe/gruvbox-material'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'luisiacc/gruvbox-baby', {'branch': 'main'}

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'nvim-tree/nvim-tree.lua'
Plug 'folke/which-key.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

Plug 'Hoffs/omnisharp-extended-lsp.nvim'
Plug 'Decodetalkers/csharpls-extended-lsp.nvim'

Plug 'nvim-lualine/lualine.nvim'

"Plug 'L3MON4D3/LuaSnip'

Plug 'sirver/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp'
"Plug 'saadparwaiz1/cmp_luasnip'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

Plug 'akinsho/bufferline.nvim', { 'tag': 'v3.*' }

Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim'

Plug 'rest-nvim/rest.nvim'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
call plug#end()
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Sessions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:session_autosave_periodic = 1
let g:session_autosave_silent = 1
let g:session_autoload = 'yes'
" The following uses the directory name as a session name to support directory-based sessions
let g:session_default_name = fnamemodify(getcwd(), ':t')

" Looks like it's not so frequent
"nnoremap <leader>wsn :SaveSession<CR> " Start new session
"nnoremap <leader>wsd :DeleteSession<CR> " Delete the session

" indent-blankline {{{
"
let g:indent_blankline_use_treesitter = v:true
let g:indent_blankline_use_treesitter_scope = v:true

" }}}

" Settings: {{{
"
" Most part of the settings is in .vimrc.common,
" we just place overrides/customizations here

set completeopt=menuone,noinsert,noselect

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable " Disable folding at startup.

" }}}

" Colors: {{{
colorscheme gruvbox-material
" }}}

call sign_define("DiagnosticSignError", {
\ "text" : "•",
\ "texthl" : "DiagnosticSignError"})

call sign_define("DiagnosticSignWarn", {
\ "text" : "•",
\ "texthl" : "DiagnosticSignWarn"})

call sign_define("DiagnosticSignInfo", {
\ "text" : "·",
\ "texthl" : "DiagnosticSignInfo"})

call sign_define("DiagnosticSignHint", {
\ "text" : "·",
\ "texthl" : "DiagnosticSignHint"})

lua << END
  -- disable netrw at the very start of your init.lua (strongly advised)
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  -- set termguicolors to enable highlight groups
  vim.opt.termguicolors = true

  local function nvim_tree_on_attach(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- Default mappings. Feel free to modify or remove as you wish.
    --
    -- BEGIN_DEFAULT_ON_ATTACH
    vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,          opts('CD'))
    vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
    vim.keymap.set('n', '<C-k>', api.node.show_info_popup,              opts('Info'))
    vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
    vim.keymap.set('n', '<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
    vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
    vim.keymap.set('n', '<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
    vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
    vim.keymap.set('n', '<CR>',  api.node.open.edit,                    opts('Open'))
    vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
    vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
    vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
    vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run Command'))
    vim.keymap.set('n', '-',     api.tree.change_root_to_parent,        opts('Up'))
    vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
    vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
    vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
    vim.keymap.set('n', 'c',     api.fs.copy.node,                      opts('Copy'))
    vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
    vim.keymap.set('n', '[c',    api.node.navigate.git.prev,            opts('Prev Git'))
    vim.keymap.set('n', ']c',    api.node.navigate.git.next,            opts('Next Git'))
    vim.keymap.set('n', 'd',     api.fs.remove,                         opts('Delete'))
    vim.keymap.set('n', 'D',     api.fs.trash,                          opts('Trash'))
    vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
    vim.keymap.set('n', 'e',     api.fs.rename_basename,                opts('Rename: Basename'))
    vim.keymap.set('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
    vim.keymap.set('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
    vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
    vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
    vim.keymap.set('n', 'g?',    api.tree.toggle_help,                  opts('Help'))
    vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
    vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
    vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
    vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
    vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
    vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
    vim.keymap.set('n', 'o',     api.node.open.edit,                    opts('Open'))
    vim.keymap.set('n', 'O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
    vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
    vim.keymap.set('n', 'P',     api.node.navigate.parent,              opts('Parent Directory'))
    vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
    vim.keymap.set('n', 'r',     api.fs.rename,                         opts('Rename'))
    vim.keymap.set('n', 'R',     api.tree.reload,                       opts('Refresh'))
    vim.keymap.set('n', 's',     api.node.run.system,                   opts('Run System'))
    vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
    vim.keymap.set('n', 'U',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
    vim.keymap.set('n', 'W',     api.tree.collapse_all,                 opts('Collapse'))
    vim.keymap.set('n', 'x',     api.fs.cut,                            opts('Cut'))
    vim.keymap.set('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
    vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
    vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
    vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
    -- END_DEFAULT_ON_ATTACH


    -- Mappings migrated from view.mappings.list
    --
    -- You will need to insert "your code goes here" for any mappings with a custom action_cb
    vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))

  end

  require("nvim-tree").setup({
    sort_by = "case_sensitive",
    live_filter = { always_show_folders = false },
    on_attach = nvim_tree_on_attach,
    view = {
      adaptive_size = true,
      preserve_window_proportions = true,
    },
    tab = {
      sync = {
        open = true,
        close = true,
      },
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = true,
    },
    actions = {
      --change_dir = {
      --  global = true,
      --},
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
      severity = {
        min = vim.diagnostic.severity.ERROR,
        max = vim.diagnostic.severity.ERROR,
      },
    },
  })

  require("bufferline").setup{
    options = {
      mode = "tabs",
      diagnostics = "nvim_lsp",
      indicator = { style = "underline" },
      tab_size = 12,
      max_name_length = 32,
      max_prefix_length = 32,
    },
    highlights = {
      buffer_selected = {
        italic = false
      }
    }
  }

  local wk = require("which-key")
  wk.setup{}

  -- nvim-tree mappings
  wk.register({
    n = {
      name = "File tree",
      t = { "<cmd>NvimTreeToggle<cr>", "Toggle file tree" },
      f = { "<cmd>NvimTreeFindFile<cr>", "Find file in tree" },
      n = { "<cmd>NvimTreeFocus<cr>", "Focus file tree" }
    }
  }, { prefix = "<leader>" })

  -- Set up nvim-cmp.
  local cmp = require'cmp'
  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'ultisnips' },
    }, {
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Telescope
  local fzf_opts = {
    fuzzy = true,                    -- false will only do exact matching
    override_generic_sorter = true,  -- override the generic sorter
    override_file_sorter = true,     -- override the file sorter
    case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                     -- the default case_mode is "smart_case"
  }

  local telescope = require("telescope")
  telescope.setup{
    defaults = {
      layout_strategy = 'center',
      layout_config = { height = 0.95, width = 0.85 },
      path_display = { "tail" },
    },
    pickers = {
      lsp_dynamic_workspace_symbols = {
        fname_width = 40,
        symbol_width = 95,
        sorter = telescope.extensions.fzf.native_fzf_sorter(fzf_opts)
      },
      lsp_document_symbols = { fname_width = 0, symbol_width = 80 },
    },
    extensions = {
      fzf = fzf_opts
    }
  }

  require('telescope').load_extension('fzf')
  require("telescope").load_extension("ui-select")

  -- Mappings.
  local builtin = require('telescope.builtin')

  wk.register({
    f = {
      name = "Find...",
      f = { builtin.find_files, "File" },
      k = { builtin.keymaps, "Keymap" },
      c = { builtin.commands, "Command" },
      C = { builtin.command_history, "Search in command history" },
      g = { builtin.live_grep, "Search in files" },
      b = { builtin.buffers, "Buffer" },
      h = { builtin.help_tags, "Help tag" },
      s = { builtin.lsp_dynamic_workspace_symbols, "Workspace symbol" }
    }
  }, { prefix = "<leader>" })

  wk.register({
    ["<leader>d"] = { name = "Diagnostics" },
    ["[d"] = { vim.diagnostic.goto_prev, "Previous diagnostic" },
    ["]d"] = { vim.diagnostic.goto_next, "Next diagnostic" },
    ["<leader>dw"] = { builtin.diagnostics, "Workspace diagnostics" }
  })

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }

    -- Not supported by csharp_ls
    --vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    --vim.keymap.set('n', '<leader>D', builtin.lsp_type_definitions, bufopts)

    wk.register({
      ["gd"] = { vim.lsp.buf.definition, "Goto definition" },
      ["gi"] = { builtin.lsp_implementations, "Goto implementation" },
      ["K"] = { vim.lsp.buf.hover, "Hover" },
      ["<C-k>"] = { vim.lsp.buf.signature_help, "Signature help" },
    }, bufopts)

    wk.register({
      f = {
        name = "Find...",
        u = { builtin.lsp_references, "Usages" },
        S = { builtin.lsp_document_symbols, "Document symbol" },
      },
      d = {
        name = "Diagnostics",
        b = { function() builtin.diagnostics { bufnr = 0 } end, "Show buffer diagnostics in Telescope" },
        k = { vim.diagnostic.open_float, "Show disgnostics under cursor" },
        l = { vim.diagnostic.setloclist, "Show buffer diagnostics in loclist" },
      }
    }, { prefix = "<leader>", buffer = bufnr })

    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)

    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<leader>cA', function() vim.lsp.buf.code_action { range = "%" } end, bufopts)
    vim.keymap.set({'n', 'v'}, '<leader>=', function() vim.lsp.buf.format { async = true } end, bufopts)

    if client.name == "omnisharp" then
      print(vim.inspect(client.server_capabilities))
      client.server_capabilities.semanticTokensProvider.legend = {
        tokenModifiers = { "static" },
        tokenTypes = { "comment", "excluded", "identifier", "keyword", "keyword", "number", "operator", "operator", "preprocessor", "string", "whitespace", "text", "static", "preprocessor", "punctuation", "string", "string", "class", "delegate", "enum", "interface", "module", "struct", "typeParameter", "field", "enumMember", "constant", "local", "parameter", "method", "method", "property", "event", "namespace", "label", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "regexp", "regexp", "regexp", "regexp", "regexp", "regexp", "regexp", "regexp", "regexp" }
      }
    end
  end

  ---- setting up lsp-config
  local util = require('lspconfig').util

  require'lspconfig'.csharp_ls.setup{
    handlers = {
      ["textDocument/definition"] = require('csharpls_extended').handler,
    },
    root_dir = function(file, _)
      if file:sub(-#".csx") == ".csx" then
        return util.path.dirname(file)
      end
      return util.root_pattern("*.sln")(file) or util.root_pattern("*.csproj")(file)
    end,
    on_attach = on_attach,
  }

  ---- setting up lsp-config
  --local util = require('lspconfig').util
  --local capabilities = require('cmp_nvim_lsp').default_capabilities()

  --require'lspconfig'.omnisharp.setup {
  --  handlers = {
  --    ["textDocument/definition"] = require('omnisharp_extended').handler,
  --  },
  --  capabilities = capabilities,
  --  root_dir = function(file, _)
  --    if file:sub(-#".csx") == ".csx" then
  --      return util.path.dirname(file)
  --    end
  --    return util.root_pattern("*.sln")(file) or util.root_pattern("*.csproj")(file)
  --  end,
  --  on_attach = on_attach,

  --  cmd = { "omnisharp" },
  --  enable_editorconfig_support = true,
  --  enable_roslyn_analyzers = true,
  --  organize_imports_on_format = true,
  --  enable_import_completion = true,
  --  -- Specifies whether to include preview versions of the .NET SDK when
  --  -- determining which version to use for project loading.
  --  sdk_include_prereleases = true,
  --}

  require('lspconfig').yamlls.setup {
    settings = {
      yaml = {
        schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
        },
      },
    }
  }

  require'lspconfig'.emmet_ls.setup{}

  require'lspconfig'.pyright.setup{}

  require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c_sharp", "lua", "vim", "javascript", "python" },
    auto_install = true,

    highlight = {
      -- `false` will disable the whole extension
      enable = true,
    },

    indent = {
      enable = true
    },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn", -- set to `false` to disable one of the mappings
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
  }

  require('lualine').setup({
    options = {
      disabled_filetypes = { 'NvimTree' } },
      theme = 'gruvbox-material'
  })

  require('indent_blankline').setup{
    use_treesitter = true,
  }

  require('gitsigns').setup({
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, {expr=true})

      map('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, {expr=true})

      -- Actions
      map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
      map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
      map('n', '<leader>hS', gs.stage_buffer)
      map('n', '<leader>hu', gs.undo_stage_hunk)
      map('n', '<leader>hR', gs.reset_buffer)
      map('n', '<leader>hp', gs.preview_hunk)
      map('n', '<leader>hb', function() gs.blame_line{full=true} end)
      map('n', '<leader>tb', gs.toggle_current_line_blame)
      map('n', '<leader>hd', gs.diffthis)
      map('n', '<leader>hD', function() gs.diffthis('~') end)
      map('n', '<leader>td', gs.toggle_deleted)

      -- Text object
      map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
  })

  require("rest-nvim").setup
  {
    -- Open request results in a horizontal split
    result_split_horizontal = false,
    -- Keep the http file buffer above|left when split horizontal|vertical
    result_split_in_place = false,
    -- Skip SSL verification, useful for unknown certificates
    skip_ssl_verification = false,
    -- Encode URL before making request
    encode_url = true,
    -- Highlight request on run
    highlight = {
      enabled = true,
      timeout = 150,
    },
    result = {
      -- toggle showing URL, HTTP info, headers at top the of result window
      show_url = true,
      show_http_info = true,
      show_headers = true,
      -- executables or functions for formatting response body [optional]
      -- set them to nil if you want to disable them
      formatters = {
        json = "jq",
        html = function(body)
          return vim.fn.system({"tidy", "-i", "-q", "-"}, body)
        end
      },
    },
    -- Jump to request line on run
    jump_to_request = false,
    env_file = '.env',
    custom_dynamic_variables = {},
    yank_dry_run = true,
  }

END

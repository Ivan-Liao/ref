# Commands
```
uv pip <command> # will mirror the pip command
uv run <file_path> # will create .venv if does not exist from_current directory
uv sync # updates .venv without any run
uvx install <tool_name> # e.g. linter tools like ruff, same as 'uv tool install'
uv tree # shows dependencies tree
```

# Concepts
1. Auto creates common paradigms
   1. .git and .gitignore
   2. .venv when packages are installed
   3. pyproject.toml to track dependencies
   4. uv.lock for dependencies details
   5. main.py for initial python file
2. Save disk space on packages since they are only used once
   
# Setup
```
.sh
uv init <app_name>
# for existing package
uv init 

uv add <packages> # equivalent of pip install
```


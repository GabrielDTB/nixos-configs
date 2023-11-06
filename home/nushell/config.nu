$env.STARSHIP_SHELL = "nu"

def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = { || create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = ""
# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ": "
$env.PROMPT_INDICATOR_VI_NORMAL = "〉"
$env.PROMPT_MULTILINE_INDICATOR = "::: "

$env.config = {
    show_banner: false
}
$env.config = ($env.config | upsert hooks {
    pre_prompt: [
    ]
    pre_execution: [
    ]
    env_change: {
        PWD: [
        ]
    }
})

$env.config.hooks.env_change.PWD = (
    $env.config.hooks.env_change.PWD | append { ||
        if (which direnv | is-empty) {
            return
        }

        direnv export json | from json | default {} | load-env
    }
)

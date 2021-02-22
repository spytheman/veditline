import os

fn main() {
	final_editor_cmd := os.args[0][1..]
	if os.args.len < 2 {
		eprintln('Usage: `v$final_editor_cmd FILE:LINE: ...`')
		exit(1)
	}
	mut res := []string{}
	for x in os.args[1..] {
		parts := x.split(':')
		match parts.len {
			0 {
				res << x
			}
			1 {
				res << parts[0]
			}
			else {
				match final_editor_cmd {
					'emacs' { res << ['+${parts[1]}', parts[0]] }
					'kate' { res << [parts[0], '--line', parts[1]] }
					'jed' { res << [parts[0], '-g', parts[1]] }
					'vim' { res << ['+${parts[1]}', parts[0]] }
					else { res << parts[0] }
				}
			}
		}
	}
	os.execvp(final_editor_cmd, res) ?
}

import os

fn main() {
	mut final_editor_cmd := os.args[0][1..]
	if os.args.len < 2 {
		eprintln('Usage: `v$final_editor_cmd FILE:LINE: ...`')
		exit(1)
	}
	if '--install' in os.args {
		aliases_names := os.args[1..].filter(!it.starts_with('-'))
		exepath := os.executable()
		for aname in aliases_names {
			target := os.join_path('/usr/local/bin', aname)
			os.system('sudo rm -f $target')
			os.system('sudo ln -s $exepath $target')
		}
		return
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
					'e' { res << ['+${parts[1]}', parts[0]] }
					'emacs' { res << ['+${parts[1]}', parts[0]] }
					'kate' { res << [parts[0], '--line', parts[1]] }
					'jed' { res << [parts[0], '-g', parts[1]] }
					'vim' { res << ['+${parts[1]}', parts[0]] }
					else { res << parts[0] }
				}
			}
		}
	}
	if final_editor_cmd == 'e' {
		final_editor_cmd = 'emacsclient'
		res.insert(0, ['--socket-name=/run/user/1000/emacs/server', "-a=''", '-nw'])
	}
	os.execvp(final_editor_cmd, res) ?
}

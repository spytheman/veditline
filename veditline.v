import os

fn main() {
	mut final_editor_cmd := os.args[0][1..]
	if os.args.len < 2 {
		eprintln('Usage: `v${final_editor_cmd} FILE:LINE: ...`')
		exit(1)
	}
	if '--install' in os.args {
		aliases_names := os.args[1..].filter(!it.starts_with('-'))
		exepath := os.executable()
		for aname in aliases_names {
			target := os.join_path('/usr/local/bin', aname)
			os.system('sudo rm -f ${target}')
			os.system('sudo ln -s ${exepath} ${target}')
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
				file := parts[0]
				line := parts[1] or { '1' }
				column := (parts[2] or { '0' }.int() + 1).str()
				match final_editor_cmd {
					'e', 'emacs' { res << ['+${line}:${column}', file] }
					'pico', 'nano' { res << ['+${line}:${column}', file] }
					'kate' { res << [file, '--line', line, '--column', column] }
					'jed' { res << [file, '-g', line, '-f', 'goto_column(${column})' ] }
					'vim' { res << [file, '+normal ${line}G${column}|'] }
					else { res << file }
				}
			}
		}
	}
	if final_editor_cmd == 'e' {
		final_editor_cmd = 'emacsclient'
		res.insert(0, ["-a=''", '-t', '-r'])
	}
	os.execvp(final_editor_cmd, res)!
}

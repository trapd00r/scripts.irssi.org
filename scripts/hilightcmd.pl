#
# Call a custom system command when receiving a hilight.
# Originally based on hilightwin.pl work and djcraven5's idea for making remote
# computer beep through ssh.
#
# Example of use, assuming you got a ssh and beep on your remote:
# /set hilightcmd_systemcmd ssh user@host beep &
#

use strict;
use Irssi;
use POSIX;
use vars qw($VERSION %IRSSI);
use Text::Sprintf::Named qw(named_sprintf);

$VERSION = "0.1";
%IRSSI = (authors     => "Guillaume Gelin",
	  contact     => "contact\@ramnes.eu",
	  name        => "hilightcmd",
	  description => "Call a system command when receiving a hilight",
	  license     => "GNU GPLv3",
	  url         => "https://github.com/ramnes/hilightcmd");


Irssi::signal_add('print text' => sub {
    my ($dest, $text, $stripped) = @_;
    my $opt = MSGLEVEL_HILIGHT;

    if (Irssi::settings_get_bool('hilightcmd_privmsg')) {
        $opt = MSGLEVEL_HILIGHT|MSGLEVEL_MSGS;
    }

    if (($dest->{level} & ($opt))
	&& ($dest->{level} & MSGLEVEL_NOHILIGHT) == 0
	&& (Irssi::active_win()->{refnum} != $dest->{window}->{refnum}
            || Irssi::settings_get_bool('hilightcmd_currentwin'))) {

        $stripped =~ s/"/\\"/g;
        system(named_sprintf(
            Irssi::settings_get_str('hilightcmd_systemcmd'),
            message => $stripped
        ));
    }
});


Irssi::settings_add_bool('hilightcmd', 'hilightcmd_privmsg', 1);
Irssi::settings_add_bool('hilightcmd', 'hilightcmd_currentwin', 1);
Irssi::settings_add_str('hilightcmd', 'hilightcmd_systemcmd', '');

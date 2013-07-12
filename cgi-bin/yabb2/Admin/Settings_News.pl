###############################################################################
# Settings_News.pl                                                            #
###############################################################################
# YaBB: Yet another Bulletin Board                                            #
# Open-Source Community Software for Webmasters                               #
# Version:        YaBB 2.4                                                    #
# Packaged:       April 12, 2009                                              #
# Distributed by: http://www.yabbforum.com                                    #
# =========================================================================== #
# Copyright (c) 2000-2009 YaBB (www.yabbforum.com) - All Rights Reserved.     #
# Software by:  The YaBB Development Team                                     #
#               with assistance from the YaBB community.                      #
# Sponsored by: Xnull Internet Media, Inc. - http://www.ximinc.com            #
#               Your source for web hosting, web design, and domains.         #
###############################################################################

$settings_newsplver = 'YaBB 2.4 $Revision: 1.11 $';
if ($action eq 'detailedversion') { return 1; }

# Load the news from news.txt
fopen(NEWS, "$vardir/news.txt") || &fatal_error('cannot_open', "$vardir/news.txt", 1);
my $yabbnews = join('', <NEWS>);
fclose(NEWS);
# ToHTML, in case they have some crazy HTML in it like </textarea>
&ToHTML($yabbnews);
&ToChars($yabbnews);

# List of settings
@settings = (
# Begin tab
{
	name  => $settings_txt{'news'}, # Tab name
	id    => 'settings', # Javascript ID
	items => [
		{
			header => $settings_txt{'news'}, # Section header
		},
		{
			description => $admin_txt{'379'}, # Description of item (displayed on left)
			input_html => qq~<input type="checkbox" name="enable_news" value="1" ${ischecked($enable_news)}/>~, # HTML for item
			name => 'enable_news', # Variable/FORM name
			validate => 'boolean', # Regex(es) to validate against
		},
		{
			header => $settings_txt{'newsfader'},
		},
		{
			description => $admin_txt{'387'},
			input_html => qq~<input type="checkbox" name="shownewsfader" value="1" ${ischecked($shownewsfader)}/>~,
			name => 'shownewsfader',
			validate => 'boolean',
			depends_on => ['enable_news'],
		},
		{
			description => $admintxt{'41'},
			input_html => qq~<input type="text" name="maxsteps" size="3" value="$maxsteps" />~,
			name => 'maxsteps',
			validate => 'number',
			depends_on => ['enable_news', 'shownewsfader'],
		},
		{
			description => $admintxt{'42'},
			input_html => qq~<input type="text" name="stepdelay" size="3" value="$stepdelay" /> $admintxt{'ms'}~,
			name => 'stepdelay',
			validate => 'number',
			depends_on => ['enable_news', 'shownewsfader'],
		},
		{
			description => $admintxt{'40'},
			input_html => qq~<input type="checkbox" name="fadelinks" value="1" ${ischecked($fadelinks)}/>~,
			name => 'fadelinks',
			validate => 'boolean',
			depends_on => ['enable_news', 'shownewsfader'],
		},
		{
			description => $admin_txt{'389'},
			input_html => qq~<input type="text" size="7" maxlength="7" name="fadertext" value="$color{'fadertext'}" onkeyup="previewColor(this.value);" /> <span id="fadertext2" style="background-color:$color{'fadertext'}">&nbsp; &nbsp; &nbsp;</span> <img align="top" src="$defaultimagesdir/palette1.gif" style="cursor: pointer" onclick="window.open('$scripturl?action=palette;task=templ', '', 'height=308,width=302,menubar=no,toolbar=no,scrollbars=no')" alt="" border="0" />
			<script language="JavaScript1.2" type="text/javascript">
			<!--
			function previewColor(color) {
				document.getElementById('fadertext2').style.background = color;
				document.getElementsByName("fadertext")[0].value = color;
			}
			//-->
			</script>~,
			name => 'fadertext',
			validate => 'hexadecimal,alpha',
			depends_on => ['enable_news', 'shownewsfader'],
		},
		{
			description => $admin_txt{'389a'},
			input_html => qq~<input type="text" size="7" maxlength="7" name="faderbackground" value="$color{'faderbg'}" onkeyup="previewColor_0(this.value);" /> <span id="faderbackground2" style="background-color:$color{'faderbg'}">&nbsp; &nbsp; &nbsp;</span> <img align="top" src="$defaultimagesdir/palette1.gif" style="cursor: pointer" onclick="window.open('$scripturl?action=palette;task=templ_0', '', 'height=308,width=302,menubar=no,toolbar=no,scrollbars=no')" alt="" border="0" />
			<script language="JavaScript1.2" type="text/javascript">
			<!--
			function previewColor_0(color) {
				document.getElementById('faderbackground2').style.background = color;
				document.getElementsByName("faderbackground")[0].value = color;
			}
			//-->
			</script>~,
			name => 'faderbackground',
			validate => 'hexadecimal,alpha',
			depends_on => ['enable_news', 'shownewsfader'],
		},
	],
},
{
	name  => $admin_txt{'7'},
	id    => 'editnews',
	items => [
		{
			header => $admin_txt{'7'},
		},
		{
			two_rows => 1, # Use to rows to display this item
			description => $admin_txt{'670'},
			input_html => qq~<textarea cols="80" rows="35" name="news" style="width: 99%">$yabbnews</textarea>~,
			name => 'news',
			validate => 'null,fulltext',
			depends_on => ['enable_news'],
		},
	],
});

# Routine to save them
sub SaveSettings {
	my %settings = @_;

	$settings{'news'} =~ tr/\r//d;
	chomp $settings{'news'};
	&FromChars($settings{'news'});
	# news.txt stuff
	fopen(NEWS, ">$vardir/news.txt", 1) || &fatal_error('cannot_open', "$vardir/news.txt", 1);
	print NEWS $settings{'news'}; # Remove it from the hash
	fclose(NEWS);
	delete $settings{'news'};

	# Settings.pl stuff
	&SaveSettingsTo('Settings.pl', %settings);
}

1;
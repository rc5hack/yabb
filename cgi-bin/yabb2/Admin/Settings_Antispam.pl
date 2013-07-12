###############################################################################
# Settings_Antispam.pl                                                        #
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

$settings_antispamplver = 'YaBB 2.4 $Revision: 1.10 $';
if ($action eq 'detailedversion') { return 1; }

# TSC
if (-e "$vardir/spamrules.txt" ) {
	fopen(SPAM, "$vardir/spamrules.txt") || &fatal_error("cannot_open","spamrules.txt", 1);
	$spamlist = join('', <SPAM>);
	fclose(SPAM);
}

# Email Domain Filter
if (-e "$vardir/email_domain_filter.txt" ) {
	require "$vardir/email_domain_filter.txt";
}
$adomains =~ s~,~\n~g;
$bdomains =~ s~,~\n~g;

# List of settings
@settings = (
{
	name  => $settings_txt{'generalspam'},
	id    => 'spam',
	items => [
		{
			description => qq~$admin_txt{'91'}<br /><span class="small">$admin_txt{'91a'}</span>~,
			input_html => qq~<input type="text" name="post_speed_count" size="5" value="$post_speed_count" />~,
			name => 'post_speed_count',
			validate => 'number',
		},
		{
			description => qq~$admin_txt{'minlinkpost'}<br /><span class="small">$admin_txt{'minlinkpost_exp'}</span>~,
			input_html => qq~<input type="text" name="minlinkpost" size="5" value="$minlinkpost" />~,
			name => 'minlinkpost',
			validate => 'number',
		},
		{
			description => qq~$admin_txt{'92'}<br /><span class="small">$admin_txt{'93'}</span>~,
			input_html => qq~<input type="text" name="spd_detention_time" size="5" value="$spd_detention_time" />~,
			name => 'spd_detention_time',
			validate => 'number',
		},
		{
			description => $admin_txt{'408'},
			input_html => qq~<input type="text" size="4" name="timeout" value="$timeout" />~,
			name => 'timeout',
			validate => 'number',
		},
		{
			header => $settings_txt{'speedban'},
		},
		{
			description => $admin_txt{'89'},
			input_html => qq~<input type="checkbox" name="speedpostdetection" value="1" ${ischecked($speedpostdetection)}/>~,
			name => 'speedpostdetection',
			validate => 'boolean',
		},
		{
			description => $admin_txt{'90'},
			input_html => qq~<input type="text" name="min_post_speed" size="5" value="$min_post_speed" />~,
			name => 'min_post_speed',
			validate => 'number',
			depends_on => ['speedpostdetection'],
		},
	],
},
{
	name  => $tsc_txt{'2'},
	id    => 'tsc',
	items => [
		{
			description => qq~<b>$tsc_txt{'4'}</b><br /><span class="small">$tsc_txt{'3'}</span>~,
			input_html => qq~<textarea cols="60" rows="35" name="spamrules" style="width: 95%">$spamlist</textarea>~,
			two_rows => 1,
			name => 'spamrules',
			validate => 'fulltext,null',
		},
	],
},
{
	name  => $domain_filter_txt{'2'},
	id    => 'emailfilter',
	items => [
		{
			description => qq~<b>$domain_filter_txt{'4'}</b><br /><span class="small">$domain_filter_txt{'3'}</span>~,
			input_html => qq~<textarea cols="60" rows="35" name="adomains" style="width: 95%">$adomains</textarea>~,
			two_rows => 1,
			name => 'adomains',
			validate => 'fulltext,null',
		},
		{
			description => qq~<b>$domain_filter_txt{'6'}</b><br /><span class="small">$domain_filter_txt{'7'}</span>~,
			input_html => qq~<textarea cols="60" rows="35" name="bdomains" style="width: 95%">$bdomains</textarea>~,
			two_rows => 1,
			name => 'bdomains',
			validate => 'fulltext,null',
		},
	],
},
);

# Routine to save them
sub SaveSettings {
	my %settings = @_;
	
	# TSC
	$settings{'spamrules'} =~ s/\r(?=\n*)//g;
	fopen(SPAM, ">$vardir/spamrules.txt");
	print SPAM delete($settings{'spamrules'});
	fclose(SPAM);

	# email domain filter
	my @domains = (delete $settings{'adomains'}, delete $settings{'bdomains'});
	foreach (@domains){
		s~\n~,~g;
		s~\s+~~g;
		s~(^,+|,+$)~~g;
		s~,+~,~g;
		s~\@~\\@~g;
	}
	fopen(FILE, ">$vardir/email_domain_filter.txt");
	print FILE qq~\$adomains = "$domains[0]";\n~;
	print FILE qq~\$bdomains = "$domains[1]";\n~;
	print FILE qq~1;~;
	fclose(FILE);

	# Settings.pl
	&SaveSettingsTo('Settings.pl', %settings);
}

1;
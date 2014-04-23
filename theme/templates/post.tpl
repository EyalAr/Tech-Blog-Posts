<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="author" content="Eyal Arubas">

	<title>{{title}} - {{_global.title}}</title>

	<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="highlight.css">
	<link rel="stylesheet" type="text/css" href="style.css">

	<script>
		(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
			(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
			m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
		})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

		ga('create', '{{_global.ga_id}}', 'auto');
		ga('send', 'pageview');
	</script>

</head>

<body>
	<div class="container">
		<div class="row">
			<div class="col-sm-2"></div>
			<div class="col-sm-8">
				<div id="links">
					<span class="link"><a href="index.html">Index</a></span>
					<span class="link"><a href="http://about.eyalarubas.com">About & Contact</a></span>
					<span class="link"><a href="https://www.goodreads.com/review/list/7034243-eyal">Reading List</a></span>
				</div>
				<h1>{{title}}</h1>
				<div>
					{{date}}
				</div>
				{{#authors}}
				<div>
					{{name}}
				</div>
				{{/authors}}
				<hr>
				<div>
					{{{_content}}}
				</div>
				<footer class="footer">
					Generated from <a href="https://raw.githubusercontent.com/EyalAr/Tech-Blog-Posts/master/posts/{{slug}}.markdown">Markdown source</a> using <a href="https://github.com/EyalAr/Contrive">Contrive</a>.
				</div>
			</div>
			<div class="col-sm-2"></div>
		</div>
	</div>
</body>
</html>
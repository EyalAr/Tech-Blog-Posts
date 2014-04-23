<html>
<head>
	<title>{{title}}</title>
	<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="highlight.css">
	<link rel="stylesheet" type="text/css" href="style.css">
	<style type="text/css">
		iframe{
			width: 100%;
			border: solid 1px #ccc;
			border-radius: 5px;
		}
	</style>
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
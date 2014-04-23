<html>
<head>
	<title>{{title}}</title>
	<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="highlight.css">
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
				<h1>{{title}}</h1>
				<div>
					{{date.day}}/{{date.month}}/{{date.year}}
				</div>
				{{#authors}}
				<div>
					{{name}} &lt;{{email}}&gt;
				</div>
				{{/authors}}
				<hr>
				<div>
					{{{_content}}}
				</div>
			</div>
			<div class="col-sm-2"></div>
		</div>
	</div>
</body>
</html>
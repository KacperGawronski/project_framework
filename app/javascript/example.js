
function gen_value(){
	var client = new XMLHttpRequest();
	var contentTEXT="";
	function parse_obj(Obj){
		contentTEXT +="<tr>"
		for(k in Obj){
			contentTEXT +="<td>"+Obj[k]+"</td>"
		}
		contentTEXT +="</tr>"
	}

	client.open('GET', '/api.json?limit=30');
	client.onreadystatechange = function() {
	  contentTEXT += "<table>"
	  (JSON.parse(client.responseText)).forEach(parse_obj)
	  contentTEXT +="</table>";
	}
	client.send();
	return contentTEXT;
}


document.getElementById("example").innerHTML = gen_value

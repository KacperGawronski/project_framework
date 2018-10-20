function get_value(){
	var client = new XMLHttpRequest();
	var contentTEXT = "<table>"
	function parse_obj(Obj){
		contentTEXT +="<tr>"
		for(k in Obj){
			contentTEXT +="<td>"+Obj[k]+"</td>"
		}
		contentTEXT +="</tr>"
	}	
	client.open('GET', '/api.json?limit=30');
	client.onreadystatechange = function() {
		document.getElementById("example").innerHTML = JSON.parse(client.responseText)[0]["emp_no"]
	}
	client.send();
	contentTEXT +="</table>";
	return contentTEXT;	
}

get_value()

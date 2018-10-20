function get_value(){
	var client = new XMLHttpRequest();
	client.open('GET', '/api.json?limit=30');
	client.onreadystatechange = function() {		
		var contentTEXT = "<table><tr id=\"table_header\">"
		function parse_obj(Obj){
			contentTEXT +="<tr>"
			for(k in Obj){
				contentTEXT +="<td>"+Obj[k]+"</td>"
			}
			contentTEXT +="</tr>"
		}	
		var responseArray = JSON.parse(client.responseText);
		for (k in responseArray[0]){
			contentTEXT+="<td><form action=\"javascript:get_value();\" onsubmit=\"return get_value()\" id=\""+k+"\">"+k+"</br><input class=\"QUERY\" id=\"search"+k+"\"></form></td>"
		}
		contentTEXT += "</tr>"
		responseArray.forEach(parse_obj);
		contentTEXT +="</table>";
		document.getElementById("example").innerHTML = contentTEXT
	}
	client.send();
}

get_value()

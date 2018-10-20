

function get_val_from_request(){
	var query="/api.json?limit=100";
	function append_q(val){
		if(val.value){query+="&"+val.name+val.value;}
	}
	var query_parts=document.getElementsByClassName("QUERY");
	for(i=0;i<query_parts.length;i++){
		append_q(query_parts[i]);
	}
	
	var client = new XMLHttpRequest();
	
	client.open('GET', query);
	document.getElementById("banner").innerHTML = query;
	client.onreadystatechange = function() {		
		var contentTEXT = "<table style=\"display:block;\"><tr id=\"table_header\">"
		function parse_obj(Obj){
			contentTEXT +="<tr>"
			for(k in Obj){
				contentTEXT +="<td>"+Obj[k]+"</td>"
			}
			contentTEXT +="</tr>"
		}	
		var responseArray = JSON.parse(client.responseText);
		for (k in responseArray[0]){
			contentTEXT+="<td><form action=\"javascript:get_val_from_request();\" name=\""+k+"\">"+k+"</br><input name=\""+k+"\" class=\"QUERY\"></form></td>"
		}
		contentTEXT += "</tr>"
		responseArray.forEach(parse_obj);
		contentTEXT +="</table>";
		document.getElementById("example").innerHTML = contentTEXT
	}
	client.send();
}

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
			contentTEXT+="<td><form action=\"javascript:void(0);\" onsubmit=\"get_val_from_request()\" id=\""+k+"\">"+k+"</br><input class=\"QUERY\" value=\"\"></form></td>"
		}
		contentTEXT += "</tr>"
		responseArray.forEach(parse_obj);
		contentTEXT +="</table>";
		document.getElementById("example").innerHTML = contentTEXT
	}
	client.send();
}

get_value()

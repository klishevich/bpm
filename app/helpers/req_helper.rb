module ReqHelper
  def req_edit_header(h2, link, link_name, name)
	raw '<div class="row wrapper border-bottom white-bg page-heading">
	  <div class="col-lg-10">
	    <h2>' + h2 + '</h2>
	      <ol class="breadcrumb">
	        <li><a href="/">Главная</a></li>
	        <li><a href="/' + link + '">' + link_name + '</a></li>      
	        <li>' + link_to(name + " #{@req.id}", @req) + '</li>          
	        <li class="active"><strong>Редактирование</strong></li>
	      </ol>    
	  </div>
	</div>'
  end
end

/*initializing best in place gem */
$(document).ready(function() {
	/*console.log('best_in_place initialized');
  /* Activating Best In Place */
 
 /*
  jQuery(".best_in_place").best_in_place();
  $('.best_in_place').bind("ajax:success", function () {$(this).closest('td').effect('highlight'); });
	$('.best_in_place').bind("ajax:success", function(){ alert('Name updated for '+$(this).data('message')); });
	*/
});


function myFunction(tableId) {
	var data = $(tableId).data('source');
	 var table = $(tableId).DataTable({
	 	  "bProcessing": true,
          "bServerSide": true,
          "scrollX": true,
          "aLengthMenu": [
        					[25, 50, 100, 200, -1],
        					[25, 50, 100, 200, "All"]
    					 ],
    	  "iDisplayLength": -1,
    	   // "ajax": {

    //"dataSrc": $(tableId).data('source')
  //}

					    /*
					    "dataSrc": function ( json ) {
					      for ( var i=0, ien=json.data.length ; i<ien ; i++ ) {
					        json.data[i][0] = 'link_to('+json.data[i][0]+')';
					      }
					      return json.data;
					    }
					    }*/
         
          "sAjaxSource": data
           


          /*
          "sAjaxSource": {
          	"data": function(d) {d.searching = get_search($(tableId));},
          	type: "post"
          }*/
       } );
       /*
        *        debugger;
           /* Apply the jEditable handlers to the table */
    /*table.$('td').editable( 'index.json', {
        "callback": function( sValue, y ) {
            var aPos = oTable.fnGetPosition( this );
            oTable.fnUpdate( sValue, aPos[0], aPos[1] );
        },
        "submitdata": function ( value, settings ) {
            return {
                "row_id": this.parentNode.getAttribute('id'),
                "column": oTable.fnGetPosition( this )[2]
            };
        },
        "height": "14px",
        "width": "100%"
    } );*/
        

    $('select.column_filter').change( function () {	//$('.column_filter').change( function () {
      	console.log("sweeet");
      	//console.log(String($('#col1_filter').val()));
		//debugger;
		//alert(String($(this).attr('id')));
		console.log(String($(this).parents('tr').attr('data-column')));
        filterColumn( $(this).parents('tr').attr('data-column'),  tableId);
    } );
    $('input.column_filter').on( 'keyup click', function () {
      	console.log("Whoops");
      	//console.log(String($('#col1_filter').val()));
		//debugger;
        filterColumn( $(this).parents('tr').attr('data-column'),  tableId);
    } );
    		/*
		 *     	    "ajax": {
					    "url": $(tableId).data('source'),
					    "dataSrc": function ( json ) {
					      for ( var i=0, ien=json.data.length ; i<ien ; i++ ) {
					        json.data[i][0] = 'link_to('+json.data[i][0]+')';
					      }
					      return json.data;
					    }
					    },
		 */
          /*
          "sAjaxSource": {
          	"data": function(d) {d.searching = get_search($(tableId));},
          	type: "post"
          }*/
       
	 /*table.columns().every(function() {
    var that = this;
    //table.rows().invalidate().draw();
    $('input', this.footer()).on('keyup', function(e) {
        that.search(this.value).draw();
    }*/
}


function filterColumn ( i , tableId) {
$(tableId).DataTable().column( i ).search(
        $('#col'+i+'_filter').val()
).draw();
}

    
    /*
     * 
     *       columns: [
        { sortable: true, searchable: false },
        { sortable: true, searchable: false },
        { sortable: true, searchable: true },
        { sortable: false, searchable: false }
      ],
      order: [1, 'desc']
     * 
     * 
     * {
    	"aLengthMenu": [
        [25, 50, 100, 200, -1],
        [25, 50, 100, 200, "All"]
    ],
    "iDisplayLength": -1,
    "info": true,
    "autoWidth": true
    } 
    
            "oLanguage": {
            "sUrl": "media/language/de_DE.txt",
            "sZeroRecords": "There are no records that match your search criterion",
            "sLengthMenu": "Display _MENU_ records per page",
            "sInfo": "Displaying _START_ to _END_ of _TOTAL_ records",
            "sInfoEmpty": "Showing 0 to 0 of 0 records",
            "sInfoFiltered": "(filtered from _MAX_ total records)"
        }, 
     */
    
            /*"initComplete": function () {
            this.api().columns().every( function () {
                var column = this;
                var select = $('<select><option value=""></option></select>')
                    .appendTo( $(column.footer()).empty() )
                    .on( 'change', function () {
                        var val = $.fn.dataTable.util.escapeRegex(
                            $(this).val()
                        );
                        column
                            .search( val ? '^'+val+'$' : '', true, false )
                            .draw();});
                 column.data().unique().sort().each( function ( d, j ) {
                    select.append('<option value="'+d+'">'+d+'</option>');});
            } );
        }
        
        });
                  // Apply the search
           table.columns().eq( 0 ).each( function ( colIdx ) {
               $( 'input', table.column( colIdx ).footer() ).on( 'keyup change', function () {
                   table
                       .column( colIdx )
                       .search( this.value )
                       .draw();
               } );
           } );
          
        
        /*
    $(tableId).DataTable({
    	"aLengthMenu": [
        [25, 50, 100, 200, -1],
        [25, 50, 100, 200, "All"]
    ],
    "iDisplayLength": -1});*/
    
    //"order": [[ 3, "desc" ]]
    //"lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]]
    //
    /*
   $('#example1').DataTable({
      "paging": true,
      "lengthChange": false,
      "searching": true,
      "ordering": true,
      "info": true,
      "autoWidth": true
    });*/

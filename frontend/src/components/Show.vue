<template>
  <div>
    <table class="table table-bordered">
      <thead>
        <tr>
        <th>ID</th>
        <th>Top</th>
        <th>Left</th>
        <th>Width</th>
        <th>Height No</th>
        <th>Label</th>
        </tr>
      </thead>
      <tbody style="color: #D1CDC8 ;">
        <tr v-for="annotate in annotations" :key="annotate.id">
          <td>{{annotate.ID}}</td>
          <td>{{annotate.topValue}}</td>
          <td>{{annotate.leftValue}}</td>
          <td>{{annotate.width}}</td>
          <td>{{annotate.height}}</td>
          <td>{{annotate.class_id}}</td>
        </tr>
      </tbody>
    </table>
  </div>
  <div class="col-md-2">
            <button class="btn btn-primary" style="background-color:#04AA6D; border-color: #04AA6D;" @click="saveAnnotation">Download</button>
          </div>
</template>

<script>
import axios from 'axios';
import { saveAs } from 'file-saver';

export default {
  name: "Show",
  data() {
    return {
      annotations: {}
    }
  },
  mounted(){
    this.loadAnnotationsTable();
  },
  methods: {
    loadAnnotationsTable: function(){
      axios.get("/api/annotations").then((res) => {
        this.annotations = res.data.data;
      })
      .catch(()=>{
        console.log("Something Went Wrong");
      })
    },

    saveAnnotation(){
      axios.get("/api/annotations").then((res) => {
        this.annotations2 = res.data.data;
         var annotations2 = JSON.parse(JSON.stringify(this.annotations2))
         var string = ["ID"+" "+"Label"+" "+"Top"+" "+ "Left"+" "+"Width"+" "+"Height"+"\n"+"\n"];
      for(var i = 0; i < annotations2.length; i++) {
        var a = annotations2[i].ID+" "+annotations2[i].class_id+" "+annotations2[i].topValue+" "+annotations2[i].leftValue+" "+annotations2[i].width+" "+annotations2[i].height+"\n";
        string.push(a);
      }
      var blob = new Blob(string, {type: "text/plain;charset=utf-8"});
      saveAs(blob, "annotations-table.txt");
         
         })
         
    }

  },
  
};
</script>


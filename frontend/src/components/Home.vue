<template>

    <div style="position: absolute; left: 600px; top: 80px">
        <h4>Your boxes</h4>
            <ul style="list-style-type: none;">
                <li v-for="(box, i) in boxes" :key="i" 
                    v-bind:class="{'active': i===activeBoxIndex}">
                    <select v-model="box.label" class="form-select" >
                    <option v-for="L in labels_list" :key="L.id" v-on:click="makeBoxActive(i)">{{L.label_id}}</option>

                  </select>
                    
                </li>
            </ul>
    </div>

    <div class="row">
      <div class="col-md-6">
        <div class="row mt-4">
          <div class="col-md-2">
          <div style="width:500px">
          <input
            class="form-control form-control-lg"
            ref="fileInput"
            type="file"
            id="formFileLg"
            @input="selectImgFile"
            v-on:click="removeBoxes()">
        </div>
          </div>
        </div>

        
        <div style="position: absolute;
                    left: 70px; top: 200px">
            <v-simple-table id="simpleTable">
            <template v-slot:default>
              <thead>
                <tr>
                <th class="text-center">
                    Label Id
                </th>
                <th class="text-center">
                    Top
                </th>
                <th class="text-center">
                    Left
                </th>
                <th class="text-center">
                    Width
                </th>
                <th class="text-center">
                    Height
                </th>
                </tr>
            </thead>
            <tbody>
                <tr
                  v-for="box in boxes"
                  :key="box.name"
                >
                  <td>{{ box.label }}</td>
                  <td>{{ box.top }}</td>
                  <td>{{ box.left }}</td>
                  <td>{{ box.width }}</td>
                  <td>{{ box.height }}</td>
                </tr>
              </tbody>
            </template>
          </v-simple-table>
           </div>
      </div>

      <div
          class="previewBlock"
          :style="{ 'background-image': `url(${filePreview})` }"
          @mousedown="startDrawingBox"
             @mousemove="changeBox"
             @mouseup="stopDrawingBox">
            <Box v-if="drawingBox.active"
                 :b-width="drawingBox.width"
                 :b-height="drawingBox.height"
                 :b-top="drawingBox.top"
                 :b-left="drawingBox.left"/>
            <Box v-for="(box, i) in boxes" :key="i"
                 :b-top="box.top" :b-left="box.left"
                 :b-label="box.label"
                 :b-width="box.width" :b-height="box.height"
                 :b-active="i===activeBoxIndex"
                 :on-select="makeBoxActive" :b-index="i"
                 :on-delete="removeBox"
            />
        </div>

      <div class="col-md-7">
        <div class="row mt-4" >
          <div class="col-md-2" style="position: absolute; left: 400px; top: 200px; " >
            <button class="btn btn-primary" style="background-color:#04AA6D; border-color: #04AA6D;" @click="removeBoxes()">Delete Boxes</button>
          </div>
          <div class="col-md-2" style="position: absolute; left: 560px; top: 200px;">
            <b-button class="btn btn-primary" type="submit" style="background-color:#04AA6D; border-color: #04AA6D; width: 200%;" @click="saveAnnotation()">Download Annotation</b-button>
          </div>
          <div class="col-md-2" style="position: absolute; left: 850px; top: 200px;">
            <button class="btn btn-primary" style="background-color:#04AA6D; border-color: #04AA6D;" @click="SaveToDB">Save</button>
          </div>
        </div>
      </div>
    </div>
</template>

<script>
import axios from 'axios';
import Box from "./Box";
import {pick} from 'lodash';
import { saveAs } from 'file-saver';

const getCoursorLeft = (e) => {
        return e.pageX - 10;
    };

    const getCoursorTop = (e) => {
        return e.pageY - 10;
    };

export default {
  name: "Home",
  components: {Box},
  data() {
    return{
      filePreview: null,
            drawingBox: {
                    active: false,
                    top: 0,
                    left: 0,
                    height: 0,
                    width: 0
                },
        boxes: [],
        labels_list: [],
    }
  },
  mounted(){
    this.loadLabelsTable();
  },
  methods: {
    startDrawingBox(e) {
                this.drawingBox = {
                    width: 0,
                    height: 0,
                    top: getCoursorTop(e),
                    left: getCoursorLeft(e),
                    active: true,
                };
            },
            changeBox(e) {
                if (this.drawingBox.active) {
                    this.drawingBox = {
                        ...this.drawingBox,
                        width: getCoursorLeft(e) - this.drawingBox.left,
                        height: getCoursorTop(e) - this.drawingBox.top,
                    };
                }
            },
            stopDrawingBox() {
                if (this.drawingBox.active) {
                    if (this.drawingBox.width > 5) {
                        this.boxes.push({...pick(this.drawingBox, ['width', 'height', 'top', 'left'])});
                    }
                    this.drawingBox = {
                        active: false,
                        top: 0,
                        left: 0,
                        height: 0,
                        width: 0
                    }
                }
            },
            makeBoxActive(i) {
            this.activeBoxIndex = i;
          },
          removeBox(i) {

            this.boxes = this.boxes.filter((elem, index) => {
                return index !== i;
            });
            this.activeBoxIndex = null;
        },

        removeBoxes() {
            var boxes = JSON.parse(JSON.stringify(this.boxes))
            for(var i = 0; i < boxes.length; i++) { 
              this.boxes.splice(i)
            }
            this.activeBoxIndex = null;
        },

          selectImgFile () {
            let fileInput = this.$refs.fileInput
            let imgFile = fileInput.files

            if (imgFile && imgFile[0]) {
              let reader = new FileReader
              reader.onload = e => {
                this.filePreview = e.target.result
              }
              reader.readAsDataURL(imgFile[0])
              this.$emit('fileInput', imgFile[0])
            }
          },

        loadLabelsTable: function(){
          axios.get("/api/labels").then((res) => {
            this.labels_list = res.data.data;
          })
          .catch(()=>{
            console.log("Something Went Wrong");
          })
        },
        
          saveAnnotation() {
              console.log(this.boxes)
              // save to txt 
                var boxes = JSON.parse(JSON.stringify(this.boxes))
                var string = [];
               
                for(var i = 0; i < boxes.length; i++) {
                  var a = boxes[i].label+" "+boxes[i].top+" "+boxes[i].left+" "+boxes[i].width+" "+boxes[i].height+"\n";
                  string.push(a);
                }
              var blob = new Blob(string, {type: "text/plain;charset=utf-8"});
              saveAs(blob, "annotation.txt");
        },

    SaveToDB: function() {
      var boxes = JSON.parse(JSON.stringify(this.boxes))
               
                for(var i = 0; i < boxes.length; i++) {
                  axios.post("/api/annotation", {
                  top: boxes[i].top,
                  left: boxes[i].left,
                  width: boxes[i].width,
                  height: boxes[i].height,
                  label: boxes[i].label
          })
                 
        }
      }
    }
};
</script>

<style lang="scss" scoped>

#label-bar {
            float: right;
            margin-right: 50px;
            width: 220px;

            ul {
                padding: 0;

                li {
                    list-style-type: none;
                    padding: 8px 16px;

                    &.active {
                        background-color: lightblue;
                    }

                    a {
                        cursor: pointer;
                        display: inline-block;
                        margin-left: 4px;
                        font-weight: bold;
                        color: red;
                    }
                }
            }
        }

img {
  height: 500px;
}

.col-md-7{
  position: relative;
  left: 500px;
  bottom: 200px;
}

.previewBlock {
      display: block;
      cursor: crosshair;
      width: 500px;
      height: 480px;        
      margin: 0 auto 20px;
      background-position: center center;
      background-size: cover;
  }

#simpleTable {
  font-family: Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

#simpleTable td, #simpleTable th {
  border: 1px solid #ddd;
  padding: 8px;
}

#simpleTable tr:nth-child(even){background-color: #f2f2f2;}

#simpleTable tr:hover {background-color: #ddd;}

#simpleTable th {
  padding-top: 12px;
  padding-bottom: 12px;
  text-align: left;
  background-color: #04AA6D;
  color: white;
}

</style>

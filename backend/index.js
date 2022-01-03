const express = require("express");
const bodyParser = require("body-parser");
const mysql = require("mysql");

const app = express();
app.use(bodyParser());

const connection = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "annotationsdatabase"
});

connection.connect((err) => {
    if (err) throw err;
    console.log("Connected successfully to MySql server")
});


app.get("/", (req, res) => {
    res.send("Hello From The Server");
})

app.post("/api/annotation", (req, res) => {
    console.log("Requesey..	");
    let top = req.body.top;;
    let left = req.body.left;
    let width = req.body.width;
    let height = req.body.height;
    let label = req.body.label;

        let query = `INSERT INTO ANNOTATIONS (topValue, leftValue, width, height, class_id) VALUES ('${top}', '${left}', '${width}', '${height}', '${label}')`;

        connection.query(query, (err, result) => {
            if (err) {
                // status code 500 is for Internal Server Error
                res.json(500, {
                    msg: "Some thing went wrong please try again"
                })
            }

            // if we reach till this point means record is inserted succesfully


            res.json(200, {
                msg: "Student Registered Succesfully",
            })
        })

});


app.get("/api/annotations", (req, res) => {
    let query = "SELECT * FROM ANNOTATIONS";

    connection.query(query, (err, result) => {
        if (err) {
            res.json(500, {
                msg: "Internal Server Error Please Try Again"
            })
        }

        res.send(200, {
            msg: "All the data fetched successfully",
            data: result
        })
    })
})

app.get("/api/labels", (req, res) => {
    let query = "SELECT label_id FROM LABELS";

    connection.query(query, (err, result) => {
        if (err) {
            res.json(500, {
                msg: "Internal Server Error Please Try Again"
            })
        }

        res.send(200, {
            msg: "All the data fetched successfully",
            data: result
        })
    })
})



app.listen(3000, () => {
    console.log("Server started ...");
});
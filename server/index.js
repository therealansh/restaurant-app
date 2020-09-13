const mysql = require('mysql');
const express = require('express');
const bodyparser = require('body-parser');
var app = express();
app.use(bodyparser.json());

var mysqlConnection = mysql.createConnection({
    host:'localhost',
    user:'root',
    password:'ansh@2212',
    database:'products',
    multipleStatements:true
});

var sqlConnection = mysql.createConnection({
    host:'localhost',
    user:'root',
    password:'ansh@2212',
    database:'users',
    multipleStatements:true
});

var orderConnection = mysql.createConnection({
    host:'localhost',
    user:'root',
    password:'ansh@2212',
    database:'orders',
    multipleStatements:true
});

mysqlConnection.connect((err) => {
    if(!err)
    console.log('woohoo');
    else
    console.log('shit' + JSON.stringify(err,undefined,2));
});

orderConnection.connect((err) => {
    if(!err)
    console.log('woohoo');
    else
    console.log('shit' + JSON.stringify(err,undefined,2));
});

sqlConnection.connect((err) => {
    if(!err)
    console.log('woohoo');
    else
    console.log('shit' + JSON.stringify(err,undefined,2));
});

const port = process.env.PORT || 8080;
app.listen(port,()=>console.log(`listening on port ${port}`));

app.get('/products',(req,res)=>{
    mysqlConnection.query('SELECT * FROM products', (err,rows,fields)=>{
        if(!err)
        res.send(rows);
        else
        console.log(err);
    });  
});

app.get('/products/:id', (req,res)=>{
    mysqlConnection.query('SELECT * FROM products WHERE id= ?',[req.params.id],(err,rows,fields) => {
        if(!err)
        res.send(rows);
        else
        console.log(err);
    });
});

app.post('/products',(req,res)=>{
    let product = req.body;
    var sql = "SET @id = ?; SET @name = ?;SET @category = ?;SET @description = ?; SET @price = ?;SET @imageURL = ?;CALL productAddOrEdit(@id,@name,@price,@description,@category,@imageURL);";
    mysqlConnection.query(sql,[product.id,product.name,product.category,product.description,product.price,product.imageURL],(err,rows,fields)=>{
        if(!err)
        rows.forEach(element=>{
            if(element.constructor == Array)
            res.send('New id:'+element[0].id);
        });
        else
        console.log(err);
    })
});

app.post('/products',(req,res)=>{
    let product = req.body;
    var sql = "SET @id = ?; SET @name = ?;SET @category = ?;SET @description = ?; SET @price = ?;SET @imageURL = ?;CALL productAddOrEdit(@id,@name,@price,@description,@category,@imageURL);";
    mysqlConnection.query(sql,[product.id,product.name,product.category,product.description,product.price,product.imageURL],(err,rows,fields)=>{
        if(!err)
        res.send('Product Details Updated Successfully');
        else
        console.log(err);
    })
});

app.delete("/products/:id", (req,res)=>{
    mysqlConnection.query('DELETE FROM products WHERE id = ?', [req.params.id],(err,rows,fields)=>{
        if(!err)
        res.send("Deleted");
        else
        console.log(err);
    })
})

app.post('/users',(req,res)=>{
    let user = req.body;
    var sql = "INSERT INTO users (uid,name,phone,address) VALUES (?,?,?,?)"
    // var sql = "INSERT INTO users SET @uid = ?; SET @name = ?;SET @phone= ?;SET @address = ?;";
    sqlConnection.query(sql,[user.uid,user.name,user.phone,user.address],(err,rows,fields)=>{
        if(!err)
        res.send("added");
        else
        console.log(err);
    })
});

app.post('/users/:uid',(req,res)=>{
    let user = req.body;
    var sql = "UPDATE users SET ? WHERE uid = ?"
    // var sql = "INSERT INTO users SET @uid = ?; SET @name = ?;SET @phone= ?;SET @address = ?;";
    sqlConnection.query(sql,[{name:user.name, address:user.address},req.params.uid],(err,rows,fields)=>{
        if(!err)
        res.send("added");
        else
        console.log(err);
    })
});

app.get('/users/:uid', (req,res)=>{
    sqlConnection.query('SELECT * FROM users WHERE uid= ?',[req.params.uid],(err,rows,fields) => {
        if(!err)
        res.send(rows);
        else
        console.log(err);
    });
});

app.get('/users',(req,res)=>{
    sqlConnection.query('SELECT * FROM users', (err,rows,fields)=>{
        if(!err)
        res.send(rows);
        else
        console.log(err);
    });  
});


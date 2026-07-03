/* BUDBAZA - cart, nav, product card */

var CART_KEY = "budbaza_cart_v1";

function fmt(n){
  return n.toLocaleString("uk-UA",{maximumFractionDigits:2}) + " \u20b4";
}

function getCart(){
  try{ return JSON.parse(localStorage.getItem(CART_KEY)) || []; }
  catch(e){ return []; }
}

function saveCart(cart){
  try{ localStorage.setItem(CART_KEY, JSON.stringify(cart)); }catch(e){}
  updateCartCount();
}

function addToCart(id, qty){
  qty = qty || 1;
  var p = PRODUCTS.find(function(x){ return x.id === id; });
  if(!p) return;
  var cart = getCart();
  var ex = cart.find(function(x){ return x.id === id; });
  if(ex){ ex.qty += qty; } else { cart.push({id: p.id, qty: qty}); }
  saveCart(cart);
  var btn = document.getElementById("add-" + id);
  if(btn){
    var old = btn.textContent;
    btn.textContent = "\u2713 \u0414\u043e\u0434\u0430\u043d\u043e";
    btn.classList.add("added");
    setTimeout(function(){ btn.textContent = old; btn.classList.remove("added"); }, 1200);
  }
  showToast(p.name + " \u2014 \u0434\u043e\u0434\u0430\u043d\u043e \u0432 \u043a\u043e\u0448\u0438\u043a");
}

function cartSum(cart){
  return (cart || getCart()).reduce(function(s, x){
    var p = PRODUCTS.find(function(pp){ return pp.id === x.id; });
    return s + (p ? p.price * x.qty : 0);
  }, 0);
}

function updateCartCount(){
  var total = getCart().reduce(function(s, x){ return s + x.qty; }, 0);
  var el = document.getElementById("cartCount");
  if(el) el.textContent = total;
  var bn = document.getElementById("bnBadge");
  if(bn){ bn.textContent = total; bn.style.display = total > 0 ? "" : "none"; }
}

var _toastT;
function showToast(msg){
  var t = document.getElementById("toast");
  if(!t){
    t = document.createElement("div");
    t.id = "toast";
    t.className = "toast";
    document.body.appendChild(t);
  }
  t.textContent = msg;
  t.classList.add("show");
  clearTimeout(_toastT);
  _toastT = setTimeout(function(){ t.classList.remove("show"); }, 2200);
}

function toggleNav(){
  document.querySelector("nav").classList.toggle("open");
}

function productCard(p){
  var unit = p.unit || "";
  var priceHtml;
  if(p.price > 0){
    priceHtml = "<div class=\"price\">" + fmt(p.price) + " <small>/ " + unit + "</small></div>" +
      "<button class=\"add\" id=\"add-" + p.id + "\" onclick=\"addToCart(" + p.id + ")\">" +
      "\uff0b \u0412 \u043a\u043e\u0448\u0438\u043a</button>";
  } else {
    priceHtml = "<div class=\"price\" style=\"font-size:.9rem;color:#666\">" +
      "\u0423\u0442\u043e\u0447\u043d\u0456\u0442\u044c \u0446\u0456\u043d\u0443</div>" +
      "<a class=\"add\" href=\"contacts.html\" style=\"text-decoration:none\">" +
      "\u0417\u0430\u043f\u0438\u0442</a>";
  }

  var stockQty = (typeof p.stock === "number") ? p.stock : 0;
  var stockHtml;
  if(stockQty > 0){
    stockHtml = "<div class=\"stock-badge in\">" +
      "\u2714 \u041d\u0430\u044f\u0432\u043d\u0456\u0441\u0442\u044c: " +
      stockQty + " " + unit + "</div>";
  } else {
    stockHtml = "<div class=\"stock-badge out\">" +
      "\u041d\u0435\u043c\u0430\u0454 \u0432 \u043d\u0430\u044f\u0432\u043d\u043e\u0441\u0442\u0456</div>";
  }

  var hitBadge = p.hit ? "<span class=\"badge hit\">\u0425\u0456\u0442</span>" : "";
  var ico = p.ico || "";
  var name = p.name || "";
  var meta = p.meta || "";
  var imgHtml = p.img
    ? "<img src=\"" + p.img + "\" alt=\"" + name + "\" loading=\"lazy\" style=\"width:100%;height:100%;object-fit:contain;\">"
    : ico;

  return "<article class=\"card\">" +
    "<a class=\"card-img\" href=\"product.html?id=" + p.id + "\" aria-label=\"" + name + "\">" +
    imgHtml + hitBadge + "</a>" +
    "<div class=\"card-body\">" +
    "<h3><a href=\"product.html?id=" + p.id + "\">" + name + "</a></h3>" +
    (meta ? "<div class=\"meta\">" + meta + "</div>" : "") +
    stockHtml +
    "<div class=\"price-row\">" + priceHtml + "</div>" +
    "</div>" +
    "</article>";
}

document.addEventListener("DOMContentLoaded", updateCartCount);

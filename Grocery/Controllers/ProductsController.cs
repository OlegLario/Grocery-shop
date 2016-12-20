using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using Grocery.Models;
using PagedList;

namespace Grocery.Controllers
{
    public class ProductsController : Controller
    {
        private GroceryModel db = new GroceryModel();
        /*[HttpGet]
        public ActionResult Index()
        {
            return View(db.Product.ToList());
        }
        // GET: Products
        [HttpPost]*/
        public ActionResult Index(string sortOrder, string currentFilter, string searchString, int? page)
        {
            ViewBag.CurrentSort = sortOrder;
            ViewBag.CompanySortParm = String.IsNullOrEmpty(sortOrder) ? "company_desc" : "";
            ViewBag.NameSortParm = sortOrder == "Name" ? "name_desc" : "Name";
            ViewBag.PackSortParm = sortOrder == "Pack" ? "pack_desc" : "Pack";
            ViewBag.PriceSortParm = sortOrder == "Price" ? "price_desc" : "Price";

            if (searchString != null)
            {
                page = 1;
            }
            else
            {
                searchString = currentFilter;
            }

            ViewBag.CurrentFilter = searchString;

            var product = from p in db.Product
                           select p;
            product = db.Product.Include(p => p.Supplier);

            if (!String.IsNullOrEmpty(searchString))
            {
                product = product.Where(p => p.ProductName.Contains(searchString));
            }
                /*if(product.Count() == 0)
                {
                    ViewBag.Error = "Current item is not found.";
                }
            }
            else
            {
                ViewBag.Error = "Please, enter this field.";
            }*/

            switch (sortOrder)
            {
                case "company_desc":
                    product = product.OrderByDescending(p => p.Supplier.CompanyName);
                    break;
                //case "name_desc":
                //    product = product.OrderByDescending(p => p.ProductName);
                //    break;
                case "Name":
                    product = product.OrderBy(p => p.ProductName);
                    break;
                case "name_desc":
                    product = product.OrderByDescending(p => p.ProductName);
                    break;
                case "Pack":
                    product = product.OrderBy(p => p.Package);
                    break;
                case "pack_desc":
                    product = product.OrderByDescending(p => p.Package);
                    break;
                case "Price":
                    product = product.OrderBy(p => p.UnitPrice);
                    break;
                case "price_desc":
                    product = product.OrderByDescending(p => p.UnitPrice);
                    break;
                default:
                    product = product.OrderBy(p => p.Supplier.CompanyName);
                    break;
            }


            int pageSize = 15;
            int pageNumber = (page ?? 1);
            //return View(product.ToList());
            return View(product.ToPagedList(pageNumber, pageSize));
        }

        // GET: Products/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Product product = db.Product.Find(id);
            if (product == null)
            {
                return HttpNotFound();
            }
            return View(product);
        }

        // GET: Products/Create
        public ActionResult Create()
        {
            ViewBag.SupplierId = new SelectList(db.Supplier, "Id", "CompanyName");
            return View();
        }

        // POST: Products/Create
        // Чтобы защититься от атак чрезмерной передачи данных, включите определенные свойства, для которых следует установить привязку. Дополнительные 
        // сведения см. в статье http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "Id,ProductName,SupplierId,UnitPrice,Package,IsDiscontinued")] Product product)
        {
            if (ModelState.IsValid)
            {
                db.Product.Add(product);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.SupplierId = new SelectList(db.Supplier, "Id", "CompanyName", product.SupplierId);
            return View(product);
        }

        // GET: Products/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Product product = db.Product.Find(id);
            if (product == null)
            {
                return HttpNotFound();
            }
            ViewBag.SupplierId = new SelectList(db.Supplier, "Id", "CompanyName", product.SupplierId);
            return View(product);
        }

        // POST: Products/Edit/5
        // Чтобы защититься от атак чрезмерной передачи данных, включите определенные свойства, для которых следует установить привязку. Дополнительные 
        // сведения см. в статье http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "Id,ProductName,SupplierId,UnitPrice,Package,IsDiscontinued")] Product product)
        {
            if (ModelState.IsValid)
            {
                db.Entry(product).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.SupplierId = new SelectList(db.Supplier, "Id", "CompanyName", product.SupplierId);
            return View(product);
        }

        // GET: Products/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Product product = db.Product.Find(id);
            if (product == null)
            {
                return HttpNotFound();
            }
            return View(product);
        }

        // POST: Products/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Product product = db.Product.Find(id);
            db.Product.Remove(product);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}

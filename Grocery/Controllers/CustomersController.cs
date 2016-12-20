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
    public class CustomersController : Controller
    {
        private GroceryModel db = new GroceryModel();

        // GET: Customers
        
        public ActionResult Index(string sortOrder, string currentFilter, string searchString, int? page)
        {
            ViewBag.CurrentSort = sortOrder;
            ViewBag.NameSotrParm = String.IsNullOrEmpty(sortOrder) ? "name_desc" : "";
            ViewBag.LastSortParm = sortOrder == "lastName" ? "lastName_desc" : "lastName";
            ViewBag.CitySotrParm = sortOrder == "city" ? "city_desc" : "city";
            ViewBag.CountrySortParm = sortOrder == "country" ? "country_desc" : "country";
            ViewBag.PhoneSortParm = sortOrder == "phone" ? "phone_desc" : "phone";

            if (searchString != null)
            {
                page = 1;
            }
            else
            {
                searchString = currentFilter;
            }
            ViewBag.CurrentFilter = searchString;
             
            var customers = from c in db.Customer
                            select c;

            if (!String.IsNullOrEmpty(searchString))
            {
                customers = customers.Where(c => c.LastName.Contains(searchString)
                                       || c.FirstName.Contains(searchString));
            }
            
            switch (sortOrder)
            {
                case "name_desc":
                    customers = customers.OrderByDescending(c => c.FirstName);
                    break;
                case "lastName":
                    customers = customers.OrderBy(c => c.LastName);
                    break;
                case "lastName_desc":
                    customers = customers.OrderByDescending(c => c.LastName);
                    break;
                case "city":
                    customers = customers.OrderBy(c => c.City);
                    break;
                case "city_desc":
                    customers = customers.OrderByDescending(c => c.City);
                    break;
                case "country":
                    customers = customers.OrderBy(c => c.Country);
                    break;
                case "country_desc":
                    customers = customers.OrderByDescending(c => c.Country);
                    break;
                case "phone":
                    customers = customers.OrderBy(c => c.LastName);
                    break;
                case "phone_desc":
                    customers = customers.OrderByDescending(c => c.LastName);
                    break;
                default:
                    customers = customers.OrderBy(c => c.FirstName);
                    break;

            }
            int pageSize = 15;
            int pageNumber = (page ?? 1);
            return View(customers.ToPagedList(pageNumber, pageSize));            
        }

        // GET: Customers/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Customer customer = db.Customer.Find(id);
            if (customer == null)
            {
                return HttpNotFound();
            }
            return View(customer);
        }

        // GET: Customers/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Customers/Create
        // Чтобы защититься от атак чрезмерной передачи данных, включите определенные свойства, для которых следует установить привязку. Дополнительные 
        // сведения см. в статье http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "Id,FirstName,LastName,City,Country,Phone")] Customer customer)
        {
            if (ModelState.IsValid)
            {
                db.Customer.Add(customer);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(customer);
        }

        // GET: Customers/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Customer customer = db.Customer.Find(id);
            if (customer == null)
            {
                return HttpNotFound();
            }
            return View(customer);
        }

        // POST: Customers/Edit/5
        // Чтобы защититься от атак чрезмерной передачи данных, включите определенные свойства, для которых следует установить привязку. Дополнительные 
        // сведения см. в статье http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "Id,FirstName,LastName,City,Country,Phone")] Customer customer)
        {
            if (ModelState.IsValid)
            {
                db.Entry(customer).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(customer);
        }

        // GET: Customers/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Customer customer = db.Customer.Find(id);
            if (customer == null)
            {
                return HttpNotFound();
            }
            return View(customer);
        }

        // POST: Customers/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Customer customer = db.Customer.Find(id);
            db.Customer.Remove(customer);
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

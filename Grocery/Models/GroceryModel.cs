namespace Grocery.Models
{
    using System;
    using System.Data.Entity;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;

    public partial class GroceryModel : DbContext
    {
        public GroceryModel()
            : base("name=groceryEntities")
        {
        }

        public virtual DbSet<Customer> Customer { get; set; }
        
        public virtual DbSet<Product> Product { get; set; }
        public virtual DbSet<Supplier> Supplier { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Product>()
                .Property(e => e.UnitPrice)
                .HasPrecision(12, 2);

            modelBuilder.Entity<Product>();
                
                

            modelBuilder.Entity<Supplier>()
                .HasMany(e => e.Product)
                .WithRequired(e => e.Supplier)
                .WillCascadeOnDelete(false);
        }
    }
}

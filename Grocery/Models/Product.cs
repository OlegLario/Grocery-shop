namespace Grocery.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Product")]
    public partial class Product
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
       

        public int Id { get; set; }

        [Required]
        [StringLength(20)]
        [Display(Name = "Product name")]
        public string ProductName { get; set; }
        [Display(Name = "Supplier id")]
        public int SupplierId { get; set; }
        [Display(Name = "Unit price")]
        public decimal? UnitPrice { get; set; }

        [StringLength(20)]
        public string Package { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]

        public virtual Supplier Supplier { get; set; }
    }
}

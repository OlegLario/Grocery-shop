namespace Grocery.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Supplier")]
    public partial class Supplier
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Supplier()
        {
            Product = new HashSet<Product>();
        }

        public int Id { get; set; }

        [Required(ErrorMessage = "The field must be set")]
        [StringLength(20, ErrorMessage = "String cannot be longer than 20 characters.")]
        [Display(Name = "Company name")]
        public string CompanyName { get; set; }

        [StringLength(20, ErrorMessage = "String cannot be longer than 20 characters.")]
        [Display(Name = "Contact name")]
        public string ContactName { get; set; }
        [Required(ErrorMessage = "The field must be set")]
        [StringLength(20, ErrorMessage = "String cannot be longer than 20 characters.")]
        public string City { get; set; }

        [StringLength(20, ErrorMessage = "String cannot be longer than 20 characters.")]
        public string Country { get; set; }
        [Required(ErrorMessage = "The field must be set")]
        [StringLength(20, ErrorMessage = "String cannot be longer than 20 characters.")]
        public string Phone { get; set; }

        [StringLength(20, ErrorMessage = "String cannot be longer than 20 characters.")]
        public string Fax { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Product> Product { get; set; }
    }
}

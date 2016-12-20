namespace Grocery.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Customer")]
    public partial class Customer
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]


        public int Id { get; set; }

        [Required(ErrorMessage = "The field must be set")]
        [StringLength(20, ErrorMessage = "String cannot be longer than 20 characters.")]
        [Display(Name = "First name")]
        public string FirstName { get; set; }

        [Required(ErrorMessage = "The field must be set")]
        [StringLength(20, ErrorMessage = "String cannot be longer than 20 characters.")]
        [Display(Name = "Last name")]
        public string LastName { get; set; }
        [Required(ErrorMessage = "The field must be set")]
        [StringLength(20, ErrorMessage = "String cannot be longer than 20 characters.")]
        public string City { get; set; }

        [StringLength(20)]
        public string Country { get; set; }
        [Required(ErrorMessage = "The field must be set")]
        [StringLength(20, ErrorMessage = "String cannot be longer than 20 characters.")]
        public string Phone { get; set; }

    }
}

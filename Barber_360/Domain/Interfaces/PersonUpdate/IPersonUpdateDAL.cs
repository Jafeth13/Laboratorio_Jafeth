using Domain.Entidades.Person;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Interfaces.PersonUpdate
{
    public interface IPersonUpdateDAL
    {
        Task<int> UpdateAsync(Person request);

    }
}

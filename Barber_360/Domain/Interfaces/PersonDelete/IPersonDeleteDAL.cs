using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Interfaces.PersonDelete
{
    public interface IPersonDeleteDAL
    {
        Task<int> DeleteAsync(int id);
    }

}

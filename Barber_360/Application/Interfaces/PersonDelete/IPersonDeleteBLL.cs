using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application.Interfaces.PersonDelete
{
    public interface IPersonDeleteBLL
    {
        Task<bool> DeleteAsync(int id);

    }
}

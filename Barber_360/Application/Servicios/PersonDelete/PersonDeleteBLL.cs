using Application.Interfaces.PersonDelete;
using Domain.Interfaces.PersonDelete;
using Domain.Interfaces.PersonUpdate;
using Infrastructure.Repositories.Person;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application.Servicios.PersonDelete
{
    public class PersonDeleteBLL : IPersonDeleteBLL
    {
        private readonly IPersonDeleteDAL _personDeleteDAL;

        public PersonDeleteBLL(
        IPersonDeleteDAL personDelete)
        {
            _personDeleteDAL = personDelete;
        }


        public async Task<bool> DeleteAsync(int id)
        {
            var result = await _personDeleteDAL.DeleteAsync(id);

            return result > 0;
        }

    }
}

using Application.Interfaces.PersonUpdate;
using Domain.Entidades.Person;
using Domain.Interfaces.PersonUpdate;

namespace Application.Servicios.PersonUpdate
{
    public class PersonUpdateBLL : IPersonUpdateBLL
    {

        private readonly IPersonUpdateDAL _updateDal;

        public PersonUpdateBLL(
        IPersonUpdateDAL updateDal) {
        _updateDal= updateDal;
        }

        public async Task<bool> UpdateAsync(Person request)
        {
            return await _updateDal.UpdateAsync(request) > 0;
        }
    }
}

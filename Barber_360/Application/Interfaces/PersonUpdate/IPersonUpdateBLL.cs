

using Domain.Entidades.Person;
namespace Application.Interfaces.PersonUpdate
{
    public interface IPersonUpdateBLL
    {
        Task<bool> UpdateAsync(Person request);
    }
}

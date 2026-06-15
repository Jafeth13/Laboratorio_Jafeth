using Domain.Entidades.Person;
using Domain.Interfaces.PersonUpdate;
using System.Data;
using Dapper;

using Infrastructure.Persistence;

namespace Infrastructure.Repositories.PersonUpdate
{
    public class PersonUpdateDAL : IPersonUpdateDAL
    {

        private readonly DapperContext _context;

        public PersonUpdateDAL(DapperContext context)
        {
            _context = context;
        }

        public async Task<int> UpdateAsync(Domain.Entidades.Person.Person request)
        {
            using var db = _context.CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@pi_Id", request.Id);
            parameters.Add("@pn_Identification", request.Identification);
            parameters.Add("@pn_Name", request.Name);
            parameters.Add("@pn_Email", request.Email);
            parameters.Add("@pd_BirthDate", request.BirthDate);

            var result = await db.ExecuteScalarAsync<int>(
                "sp_UpdatePerson",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return result;
        }
    }
}
